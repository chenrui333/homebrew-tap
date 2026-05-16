class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "a29ce86683b01caac2774109404759ed2df9610eec1aed9ad690d3577cea8da6"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "316ba207b1e14c613ab9f442a8c33f056ddcd8f00c692763ce85613c2b0739bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316ba207b1e14c613ab9f442a8c33f056ddcd8f00c692763ce85613c2b0739bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "316ba207b1e14c613ab9f442a8c33f056ddcd8f00c692763ce85613c2b0739bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aefb0118be7532453793b4db642eb55b7a606ebb31fe073cbafdc65b64bbb634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6eeea9baa65a6c1d7e771aa300ce2029896a127a50466f34eaa31842f7636eb"
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
