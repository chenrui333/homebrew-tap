class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "2c44b37987621b6a2b7aa7677fc76e1d18296838ce9f9ccda710604e15c25374"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e7bf0946bb157ee2d14c3cf0c87f955b9103094cfa66494839cf1cd22b551d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7bf0946bb157ee2d14c3cf0c87f955b9103094cfa66494839cf1cd22b551d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e7bf0946bb157ee2d14c3cf0c87f955b9103094cfa66494839cf1cd22b551d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e209f1be9b50290b5e5867224b303d28dab8a3d2f7df57f8165d2056e8c0848e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd69148bd3800814c379e10ad2f4a5a53da8b30b7e6641a49226182aa600c6a6"
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
    assert_match "error: this repository doesn't have a remote origin", output
    assert_path_exists testpath/".git/av"
  end
end
