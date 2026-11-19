class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "242f939f8aa64d9a640c813a7be72af810491764bd2201809738b81d53e31f9a"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de37502311e8db0a6d6b321ccfe487e826683fb8ce97986215df81f1c43acc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b339680e27cb62500e66d590045467b78316b8c43735bb2e800969491a37679d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bff72c1d187903b7d190681f2f0c9f76ecf0b573dce778a8e8712622f1aef4ee"
    sha256 cellar: :any,                 x86_64_linux:  "766febf3ca03bb9431136fe5583b864a330a18cad3b0cc61ebad101262664b13"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "storage:\n  default:\n    backend:\n      type: memory", cfg.read
  end
end
