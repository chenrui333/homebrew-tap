class Jolt < Formula
  desc "Battery and energy monitor for your terminal"
  homepage "https://getjolt.sh/"
  url "https://github.com/jordond/jolt/archive/refs/tags/1.2.0.tar.gz"
  sha256 "c6756b84349a6f253d81eb9ad6074f9b94461043c053b1b7ce5f86c2e1bed04d"
  license "MIT"
  revision 1
  head "https://github.com/jordond/jolt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7deb204777af2c3323975759c1101ccf5cea9dc51d09371c65526f65ba07f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb79fd2d8ed1ab27f2289f5e051cc186d3b2ac2c36d55b5e82edfa55e40d352"
    sha256 cellar: :any,                 arm64_linux:   "4b397b95abe1b0d6740c880f5ea6ce5762b18db22506ba305a485ae363acd18e"
    sha256 cellar: :any,                 x86_64_linux:  "3cb91a44c53da8dc88836a5d92feb6d2ca07cfdb7fe0a1c00f3c8555da2ef891"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # Fix the stale workspace crate versions in the upstream lockfile.
    inreplace "Cargo.lock", 'version = "1.2.0-beta.2"', "version = \"#{version}\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  service do
    run [opt_bin/"jolt", "daemon", "start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jolt --version")

    config_home = testpath/"config"
    cache_home = testpath/"cache"
    data_home = testpath/"data"
    runtime_dir = testpath/"runtime"
    env = [
      "XDG_CONFIG_HOME=#{config_home}",
      "XDG_CACHE_HOME=#{cache_home}",
      "XDG_DATA_HOME=#{data_home}",
      "XDG_RUNTIME_DIR=#{runtime_dir}",
    ].join(" ")

    output = shell_output("#{env} #{bin}/jolt config --reset")
    assert_match "Config reset to defaults at:", output

    config_file = config_home/"jolt/config.toml"
    assert_path_exists config_file
    assert_match 'theme = "default"', config_file.read
    assert_equal "#{config_file}\n", shell_output("#{env} #{bin}/jolt config --path")
  end
end
