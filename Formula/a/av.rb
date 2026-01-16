class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "5a90cb0d1a1b90a68f7961b12a2a9bec7dec5b558ef6751b4df34425457832f3"
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
    assert_match "error: this repository doesn't have a remote origin", output
    assert_path_exists testpath/".git/av"
  end
end
