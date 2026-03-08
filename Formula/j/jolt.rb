class Jolt < Formula
  desc "Battery and energy monitor for your terminal"
  homepage "https://getjolt.sh/"
  url "https://github.com/jordond/jolt/archive/refs/tags/1.2.0.tar.gz"
  sha256 "c6756b84349a6f253d81eb9ad6074f9b94461043c053b1b7ce5f86c2e1bed04d"
  license "MIT"
  revision 1
  head "https://github.com/jordond/jolt.git", branch: "main"

  depends_on "rust" => :build

  service do
    run [opt_bin/"jolt", "daemon", "start", "--foreground"]
    keep_alive true
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
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
