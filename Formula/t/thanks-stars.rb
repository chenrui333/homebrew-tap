class ThanksStars < Formula
  desc "Star GitHub repositories backing your project's dependencies"
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  url "https://github.com/Kenzo-Wada/thanks-stars/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "87153f78407d48241b767a19754e121d68da423d5562e984071a223741dbb573"
  license "MIT"
  head "https://github.com/Kenzo-Wada/thanks-stars.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    config_dir = testpath/"config"
    output = with_env(THANKS_STARS_CONFIG_DIR: config_dir.to_s) do
      shell_output("#{bin}/thanks-stars auth --token cli-token")
    end

    assert_match "Token saved", output
    assert_match version.to_s, shell_output("#{bin}/thanks-stars --version")
    assert_match "cli-token", (config_dir/"config.toml").read
  end
end
