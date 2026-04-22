class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.29.tar.gz"
  sha256 "cced9d21ddddda519c0006747a6914bfc9e81b5594318b12d9080a2485430e33"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "310b82fd825a3e78bbb1bd3865005e8235247c5b604f3c0f49a42738e890e3d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310b82fd825a3e78bbb1bd3865005e8235247c5b604f3c0f49a42738e890e3d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310b82fd825a3e78bbb1bd3865005e8235247c5b604f3c0f49a42738e890e3d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a42e42074f58f2d5c86080d5e860699ed6d32a58e3e077e8405a8d12e7b612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "981af849962b012410bf977a8277ceab899dbe545b6d0446a7e8e96e0c93581b"
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
