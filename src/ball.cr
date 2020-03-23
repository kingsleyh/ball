require "option_parser"
require "file_utils"

HOME        = CrystalVersion.home
ROOT_DIR    = "#{HOME}/.ball"
TMP_DIR     = "#{ROOT_DIR}/tmp"
INSTALL_DIR = "#{ROOT_DIR}/install"
BIN_DIR     = "/usr/local/bin"

version = ""

opts = OptionParser.parse! do |parser|
  parser.banner = "Usage: ball --show | ball --install 0.30.1"
  parser.on("-s", "--show", "Shows the installed versions of crystal") { show_versions }
  parser.on("-i VERSION", "--install=VERSION", "Install and use the specified version of crystal") { |v| version = v }
  parser.on("-c", "--clean", "Remove installed versions tmp folder") { clean_versions }
  parser.on("-v", "--version", "Ball version number") { puts "v0.1.2" }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

def show_versions
  puts "Showing versions:"
  FileUtils.mkdir_p(INSTALL_DIR) unless Dir.exists?(INSTALL_DIR)
  Dir.entries(INSTALL_DIR).select { |f| f.starts_with?("c-") }.sort.each do |e|
    puts e.split("-").last
  end
  exit(0)
end

def clean_versions
  puts "removing all versions and symlinks"
  FileUtils.rm_rf(ROOT_DIR) if Dir.exists?(ROOT_DIR)
end

if version != ""
  puts "switching to crystal version: #{version}"
  CrystalVersion.switch_to_version(version)
end

class CrystalVersion
  def self.switch_to_version(version)
    begin
      make_dirs
      process_version(version) unless has_local_version?(version)
      write_links(version)
    rescue e
      puts "Error installing version: #{version} due to: #{e.message}"
    end
  end

  def self.user
    `whoami`.strip
  end

  def self.home
    "/Users/#{user}"
  end

  def self.group
    `groups $(whoami)`.split(" ").first.strip
  end

  def self.make_dirs
    FileUtils.mkdir_p(TMP_DIR) unless Dir.exists?(TMP_DIR)
    FileUtils.mkdir_p(INSTALL_DIR) unless Dir.exists?(INSTALL_DIR)
  end

  def self.write_links(version)
    puts "Linking version: #{version}"
    `rm #{BIN_DIR}/crystal`
    `rm #{BIN_DIR}/shards`
    FileUtils.ln_sf("#{INSTALL_DIR}/c-#{version}/bin/crystal", "#{BIN_DIR}/crystal")
    FileUtils.ln_sf("#{INSTALL_DIR}/c-#{version}/embedded/bin/shards", "#{BIN_DIR}/shards")
  end

  def self.has_local_version?(version)
    Dir.exists?("#{INSTALL_DIR}/c-#{version}")
  end

  def self.process_version(version)
    fetch_version(version)
    install_version(version)
  end

  def self.fetch_version(version)
    puts "Fetching version: #{version}"
    url = "https://github.com/crystal-lang/crystal/releases/download/#{version}/crystal-#{version}-1.pkg"
    dest = "#{TMP_DIR}/crystal-#{version}-1.pkg"
    curl = `curl -L -s #{url} --output #{dest}`
  end

  def self.install_version(version)
    puts "Installing version: #{version} via installer"
    owner = "#{user}:#{group}"
    puts `sudo installer -pkg #{TMP_DIR}/crystal-#{version}-1.pkg -target / && sudo mv /opt/crystal #{INSTALL_DIR}/c-#{version} && sudo chown -R #{owner} #{INSTALL_DIR}`
  end
end
