class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "c89219b9a90585cac47baffcb5e250cc47cfb9e0a027cb127f7c1498bca064da"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30ba6ab09e9d9961042b3e3e12535db284345dc4834d050bd7f8d2d22757f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2617797f8914499a7a8d1e1c90e53aefd254cbe999c6287669fa1a0518229e45"
    sha256 cellar: :any_skip_relocation, ventura:       "29f7518d598f79ab85dd376078adda6a9d66596a26dd715b1062c2fa977395c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259e1ae0ea1c9dc25a12a5929772ab2dcfeb760c633394c219812ee077a81d98"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
