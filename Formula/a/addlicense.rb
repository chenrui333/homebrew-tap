class Addlicense < Formula
  desc "Scan directories recursively to ensure source files have license headers"
  homepage "https://github.com/google/addlicense"
  url "https://github.com/google/addlicense/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d2e05668e6f3da9b119931c2fdadfa6dd19a8fc441218eb3f2aec4aa24ae3f90"
  license "Apache-2.0"
  head "https://github.com/google/addlicense.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d104563710829813f23c36e0d39f3fe8e271318dbf3ebaf295de72bd2ba6b7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dce435e663081292d2a3bec2b5c5f87904264cbb6d08c721414a8fbf9762be56"
    sha256 cellar: :any_skip_relocation, ventura:       "2423e34bc109aa95579f84bbebc25751533762e782e475e5a70ba296bfafb95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78829b5991f8ae8eb18b5f984e2d950e2508bcf9d87f30905f190383bd41c8be"
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
