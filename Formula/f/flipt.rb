class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b2635b11477741a84d30ca7f60b9ba819625c7b1a64c7acdf80c8b675db13054"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40e5d4c39713f86ce4e9649c5ab7f5f920f07bfc7fd500d68ef613b113599273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "000a1fae37f7f85db5d8b246c8d45e37192c81b686ebc2c298645fd4eb49136a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e8e866cb6ea5e8fc0ab4811792d95d2dc56d8b889e4dae4ffd1d8a581d67cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a320f5c64425edf76d171e27bd566cf4e5912fcf0f70165cec581118149c3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca52afebd7f40918cb3d5fcf99f1c2ecbd0a37fe38c98a35974099942d033807"
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
    assert_match "diagnostics:\n  profiling:\n    enabled: true", cfg.read
  end
end
