require "option_parser"
require "file_utils"
require "crest"

TMP_DIR = "/usr/local/bin/c-tmp"

version = ""

opts = OptionParser.parse! do |parser|
  parser.banner = "Usage: ball --show | ball --install 0.30.1"
  parser.on("-s", "--show", "Shows the installed versions of crystal") { show_versions }
  parser.on("-i VERSION", "--install=VERSION", "Install and use the specified version of crystal") { |v| version = v }
  parser.on("-c", "--clean", "Remove installed versions tmp folder") { clean_versions }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

def show_versions
  puts "Showing versions:"
  Dir.entries("/usr/local/bin").select{|f| f.starts_with?("c-")}.sort.each do |e|
    puts e.split("-").last unless e.includes?("c-tmp")
  end
  exit(0)
end

def clean_versions
    puts "cleaning versions"
    removals = Dir.entries("/usr/local/bin").select{|f| f.starts_with?("c-")}.sort.map do |e|
        "/usr/local/bin/#{e}"
    end
    `sudo rm -rf #{removals.join(" ")}`
    puts "removing symlinks"
    FileUtils.rm("/usr/local/bin/crystal")
    FileUtils.rm("/usr/local/bin/shards")
end

if version != ""
  puts "switching to crystal version: #{version}"
  CrystalVersion.switch_to_version(version)
end

class CrystalVersion
  def self.switch_to_version(version)
    process_version(version) unless has_local_version?(version)
    write_links(version)
  end

  def self.write_links(version)
    puts "Linking version: #{version}"
    FileUtils.rm("/usr/local/bin/crystal")
    FileUtils.rm("/usr/local/bin/shards")
    FileUtils.ln_sf("/usr/local/bin/c-#{version}/bin/crystal", "/usr/local/bin/crystal")
    FileUtils.ln_sf("/usr/local/bin/c-#{version}/embedded/bin/shards", "/usr/local/bin/shards")
  end

  def self.has_local_version?(version)
    Dir.exists?("/usr/local/bin/c-#{version}")
  end

  def self.process_version(version)
    begin
      fetch_version(version)
      install_version(version)
    rescue e
      puts "Error installing version: #{version} due to: #{e.message}"
    end
  end

  def self.fetch_version(version)
    puts "Fetching version: #{version}"
    FileUtils.mkdir_p(TMP_DIR) unless Dir.exists?(TMP_DIR)

    Crest.get("https://github.com/crystal-lang/crystal/releases/download/#{version}/crystal-#{version}-1.pkg") do |resp|
      File.open("#{TMP_DIR}/crystal-#{version}-1.pkg", "w") do |file|
        IO.copy(resp.body_io, file)
      end
    end
  end

  def self.install_version(version)
    puts "Installing version: #{version} via installer"
    puts `sudo installer -pkg #{TMP_DIR}/crystal-#{version}-1.pkg -target / && sudo mv /opt/crystal /usr/local/bin/c-#{version}`
  end
end
