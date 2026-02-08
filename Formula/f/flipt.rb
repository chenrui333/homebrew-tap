class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b2635b11477741a84d30ca7f60b9ba819625c7b1a64c7acdf80c8b675db13054"
  # license "FCL-1.0-MIT" # Fair Core License, Version 1.0, MIT Future License
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1984fb08af3988c285f5e1767f2578a1344f8017d9789d4ef858e8c081fbbba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da4a98f4f104e5b482b938c5df94dafb16a3af003f53168089c558ad7850286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ece24bd5f0a3a74e5b3ed4b1592205aae9ac8e0767957d0f6ce225a5a31db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "702d212cb21cb3afa7b170f3379c035398f16434cf6940d570571f69058635d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ff19e1f7c5bdbd5227382e194c719f239bfe81d6c35076583cd82958a95954"
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
