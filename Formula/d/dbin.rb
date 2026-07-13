# framework: cobra
class Dbin < Formula
  desc "Easy to use, easy to get, suckless software distribution system"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.7.tar.gz"
  sha256 "386e1bfa34d13b87f768f2fceb81fe36cb22217dab613f4a820c44d43fbb063f"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f312128c3c53cd20c541279e7077f895ed5fa43d93b5d3f27830aedc0c038fe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f312128c3c53cd20c541279e7077f895ed5fa43d93b5d3f27830aedc0c038fe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f312128c3c53cd20c541279e7077f895ed5fa43d93b5d3f27830aedc0c038fe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c8341df60db159d3bc42f1fb85cfeb75016a8c066877448461c94fa71b1b227"
    sha256 cellar: :any,                 x86_64_linux:  "22abc1f099f29bafa68b5d913c5ee17b9d1133f1d89d00c64eaa90a03f70fe57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbin --version")

    # no darwin dbin metadata in https://github.com/xplshn/dbin-metadata
    return if OS.mac?

    (testpath/".local/bin").mkpath
    output = shell_output("#{bin}/dbin del bed 2>&1")
    assert_match "'bed' does not exist or was not installed by dbin", output
  end
end
