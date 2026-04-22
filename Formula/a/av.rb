class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "302b7d373f3a6ad988804c144678f43c6f2fa094aa6c9ae02ab8ba9e81fb41fb"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed3b5339778e4da292d8cb32bcb6e2b50857da4296959b606b92e8bd6c17f94c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3b5339778e4da292d8cb32bcb6e2b50857da4296959b606b92e8bd6c17f94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed3b5339778e4da292d8cb32bcb6e2b50857da4296959b606b92e8bd6c17f94c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c0410c5e2e49fc47c0ac8c6f9f446b98613b0f6ab30e0df996a2ac179f6a581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "008e004662756bdb1b9b38bc11a2de83fccd7e2c7e52ae1319656ccca44954fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aviator-co/av/internal/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/av"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av version")

    ENV["GITHUB_TOKEN"] = "testtoken"

    system "git", "init"

    output = shell_output("#{bin}/av init 2>&1", 1)
    assert_match "Failed to determine repository default branch", output
    assert_match "failed to open git repo", output
  end
end
