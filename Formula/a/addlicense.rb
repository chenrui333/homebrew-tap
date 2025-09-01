class Addlicense < Formula
  desc "Scan directories recursively to ensure source files have license headers"
  homepage "https://github.com/google/addlicense"
  url "https://github.com/google/addlicense/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d2e05668e6f3da9b119931c2fdadfa6dd19a8fc441218eb3f2aec4aa24ae3f90"
  license "Apache-2.0"
  head "https://github.com/google/addlicense.git", branch: "main"

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
