class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "d6adfa456fc096874ce16065567c3ae9898061e5bb90ab14e26706dd1f89e3f9"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8314cb9d5c70b1a924451807a3e38c528290f89c0b3221fcaab20393028ab575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf28c41ac9871d2212e39bebcd26999fd0e128bf77b3b5722cbfca479ecaeb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec1ec0f966ae1d42a2e16c389fd4022431027e3411d7e4b2a779f2b39d114b1"
    sha256 cellar: :any,                 x86_64_linux:  "196de9ffebce8fc014d30444d91abe724e5ec892733729ed6240d89b42f84398"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
