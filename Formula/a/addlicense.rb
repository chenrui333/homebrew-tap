class Addlicense < Formula
  desc "Scan directories recursively to ensure source files have license headers"
  homepage "https://github.com/google/addlicense"
  url "https://github.com/google/addlicense/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d2e05668e6f3da9b119931c2fdadfa6dd19a8fc441218eb3f2aec4aa24ae3f90"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/addlicense.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "042fe29608840adb4e0d5662624d4372df11e9c2a7f4d038828c989f85512e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "042fe29608840adb4e0d5662624d4372df11e9c2a7f4d038828c989f85512e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042fe29608840adb4e0d5662624d4372df11e9c2a7f4d038828c989f85512e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95c23547a4874fa0c7a3bff7b66301a69b4dc083fc513b309bd80fb58ea35f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ed1fb459ea0a9619498a4837911a82b25067956e15960e4482a43abe7a2e1b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write("package main\\n")
    system bin/"addlicense", "-c", "Random LLC", testpath/"test.go"
    assert_match "// Copyright 2025 Random LLC", (testpath/"test.go").read
  end
end
