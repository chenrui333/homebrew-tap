class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "5a0c4cfab4a8c8b80dee6684da1ff27b2aaeae50f3a3d931e6c2ce9b410150c1"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7eae5c6adc981942824c5f805736ace198268d85d177ce62b2fbcfa67ca2388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7eae5c6adc981942824c5f805736ace198268d85d177ce62b2fbcfa67ca2388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7eae5c6adc981942824c5f805736ace198268d85d177ce62b2fbcfa67ca2388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548ddac61e3a175fbf110ded43d95ae21a5cab0f71968e852cf8e1836b9fb646"
    sha256 cellar: :any,                 x86_64_linux:  "bc8a83ee4783fd0f2ba650e96bb220c73ae6fcddc29d062e3acea06d29f0471a"
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
