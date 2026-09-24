class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "9896af34c35067ab66dfc7df0b39b6675c1704b1671379d968e7cfd21192b90a"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e3bce9bfd3e709a907619454f0ec95d426425b1e3dc90a6265f0fda6a093f30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17561cdcbfbcd8e5e992b882a36da271f316ac8f6df9fd746d8830ea3573fdb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec82f9be717c96e5c5b45c9cacc24b6593de66781f4cc0063939422d2660928"
    sha256 cellar: :any,                 x86_64_linux:  "1c51ced713b777f72df9740080cd6aca7d06ed2c4d46d689dd2fa94d4e017b35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "storage:\n  default:\n    backend:\n      type: memory", cfg.read
  end
end
