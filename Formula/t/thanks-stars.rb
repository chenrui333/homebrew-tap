class ThanksStars < Formula
  desc "Star GitHub repositories backing your project's dependencies"
  homepage "https://github.com/Kenzo-Wada/thanks-stars"
  url "https://github.com/Kenzo-Wada/thanks-stars/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "87153f78407d48241b767a19754e121d68da423d5562e984071a223741dbb573"
  license "MIT"
  head "https://github.com/Kenzo-Wada/thanks-stars.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "923ff9c478ee461426ca2467a8cc0094c103af0269e81682ba5293c7973c2e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51202300b0b4e9cd15ec2ab63df02f2faa4a58fd44c76295af8fa3eb12532d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc594174c0a23d5fe5f9a595834d0cd2c9d919b59dbe314f14f5a8df9b050fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff3fd5dda237859cabff0e2100ecba743a16546daf3705823e7853284ca2f4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd419156d82acf38c40c5cb8d3085f7cfc134ec9433bbb7b6c4201a48e686a11"
  end

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
