class ThanksStars < Formula
  desc "Star GitHub repositories backing your project's dependencies"
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  url "https://github.com/Kenzo-Wada/thanks-stars/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "87153f78407d48241b767a19754e121d68da423d5562e984071a223741dbb573"
  license "MIT"
  head "https://github.com/Kenzo-Wada/thanks-stars.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "663f95eb3b5be2f15b91dc7a741d7a477308b2eeedc400b28af46a2f92ce34bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9bd26b455ec39c7ace6ebad995d1885a6d6a195b5032b4d796ae509d6e4b799"
    sha256 cellar: :any,                 arm64_linux:   "b1c0142a95f7fbf14ca0eea9defe578e2e4c1e9a5bc196092e731504a81216c9"
    sha256 cellar: :any,                 x86_64_linux:  "7bfc7773d57cdf94dfcd29307e42efad829bc09381bddb8d2560baa6dce25953"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
