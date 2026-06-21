class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "698a251b207147744ca62766b55221da43852efdee1ce1ae1089835d5303a37e"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35f7577f7b67f6cacab75db197c1c7f9418339f9282b3d61fc0b660509a12c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35f7577f7b67f6cacab75db197c1c7f9418339f9282b3d61fc0b660509a12c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f7577f7b67f6cacab75db197c1c7f9418339f9282b3d61fc0b660509a12c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64850e494b719e025019e4392567530226b084633093b214ed93a21b77937128"
    sha256 cellar: :any,                 x86_64_linux:  "a6db13bf87cad3ddeb5d303bf3f34bce7a0c3aabc0e95897192594b8395a6780"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
