class Yor < Formula
  desc "Extensible auto-tagger for your IaC files"
  homepage "https://yor.io/"
  url "https://github.com/bridgecrewio/yor/archive/refs/tags/0.1.199.tar.gz"
  sha256 "1852cfd744d3680d60e3af045e5129d2a714079f0707c39898d4a81040f81645"
  license "Apache-2.0"
  head "https://github.com/bridgecrewio/yor.git", branch: "main"

  depends_on "go" => :build

  def install
    inreplace "src/common/version.go", "Version = \"9.9.9\"", "Version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yor --version")

    assert_match "yor_trace", shell_output("#{bin}/yor list-tags")
    assert_match "code2cloud", shell_output("#{bin}/yor list-tag-groups")
  end
end
