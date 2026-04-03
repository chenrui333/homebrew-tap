class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "3725f2ee30eb3763040e41bb3ef3ce3d8ae5e5871300d6da294868f77f748524"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "308e71d6b575b35588eb494f87dd11793828bbee1d7e35dc02fad8078ac0c170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308e71d6b575b35588eb494f87dd11793828bbee1d7e35dc02fad8078ac0c170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308e71d6b575b35588eb494f87dd11793828bbee1d7e35dc02fad8078ac0c170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "569007290a19fdfb18d6cd536b6c337c385bdd77144ab2026664d86c7f823243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7600b1aa3699ec7e70a122535cbc7c279ec57351f7ea0db50457af0715d769"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
