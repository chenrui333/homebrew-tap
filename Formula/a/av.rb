class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "2d3d5a561a3fee5d7fb55d3b021dc5a8be12cb4fc901fede655154a2166b0ba9"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa46f356db9fe07c40b7a2b675eab474e80916c4bd2c3069d9bcd976decf6817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa46f356db9fe07c40b7a2b675eab474e80916c4bd2c3069d9bcd976decf6817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa46f356db9fe07c40b7a2b675eab474e80916c4bd2c3069d9bcd976decf6817"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abeaf3d267278b97d5fa3e120e215f0ae321156392b88432b0d8710f7710e279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6804f90dba7cfdbeee421e594e22504f9897269485ad75f9e8cdee127981072"
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
    assert_path_exists testpath/".git/av"
  end
end
