class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "5354a8fc7b52c47bc6a87b8f5c2be2afcfba4940aa5876be5993bed1c04f71bb"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb3e84730a4babc7242754fcb0112dc08c100e6bd715974162ebf21959c2371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "113beafc102c46d30df9845d1065dd7aef73ddc3eb27b511f5d0d11ed391ac09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb6cda549eccb97c54ef5c5dcbb5de228006016c0b23c0fd235275371ac05ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35103206e995cb1dfdb5de13cd1b6598114ca0af67b77f0a4bd1df15faaa6c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc8e16c06ff309076fb89949d28dd75645a412666b802b8b883715b9293c69a"
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
