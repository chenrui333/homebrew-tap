class Yor < Formula
  desc "Extensible auto-tagger for your IaC files"
  homepage "https://yor.io/"
  url "https://github.com/bridgecrewio/yor/archive/refs/tags/0.1.199.tar.gz"
  sha256 "1852cfd744d3680d60e3af045e5129d2a714079f0707c39898d4a81040f81645"
  license "Apache-2.0"
  head "https://github.com/bridgecrewio/yor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f28c48e1a2a02dcbf73eb29e9473a73a429cc5956798736c13b659497e50586e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "528cf0c2c033797c80c1310b7f45c203771d5cc66d9a8d08d61a69ae792d5ecb"
    sha256 cellar: :any_skip_relocation, ventura:       "33f7e0ddec44e46576df311dde91a431eaf0c90782b39113f4092e000cb079e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc079e7dff706a009b46c11af7ffa3daf1f00e89b495f0f79fd1ce95f8c99079"
  end

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
