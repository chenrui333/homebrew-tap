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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "525093f44a0865b41ed2d6cf36102d6da4f83ae444f89240a9d1f2ab21874858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c25b17322156fd70d85dd79a412e592f04e2199a7bca6a1168b0d8f41c1f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfc33f3eb04c5d36f398c97f28d05b4beb914aa53f0eed7cec6da9df7673240f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d03de623ccd0ba5efc9482a79ac8ec769081105047014971a55dd6db58c26e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74805dbfa0d8ff6810654a2557f3362833b8b568b51fcfb4cc32b8bb69e56d1"
  end

  depends_on "rust" => :build

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
