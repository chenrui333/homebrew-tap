class Pwdsafety < Formula
  desc "CLI checking password safety"
  homepage "https://github.com/edoardottt/pwdsafety"
  url "https://github.com/edoardottt/pwdsafety/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9c5135d01f1bcbd3db064a9e22532d539da0c36372c4e7044799ebc7bf3801e3"
  license "GPL-3.0-only"
  head "https://github.com/edoardottt/pwdsafety.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ecf822ea3c2567858ba10f3fcba23b0dc2da652b7d63a3bbd7edcdf220cfa99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ecf822ea3c2567858ba10f3fcba23b0dc2da652b7d63a3bbd7edcdf220cfa99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ecf822ea3c2567858ba10f3fcba23b0dc2da652b7d63a3bbd7edcdf220cfa99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eddb9a1c9bb4b4504382f942da9cf683b5ae3546c9e8f3c68095d242adf998a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ae2e0631ce9bf5c1b4e09d45d468c2309537f9ab0ff3e09b811a2a32b85759"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pwdsafety"
  end

  test do
    output = pipe_output("#{bin}/pwdsafety 2>&1", "123\n", 1)
    assert_match "Hey....Do you know what password cracking is?", output
  end
end
