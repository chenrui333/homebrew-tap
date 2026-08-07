class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "c465fefe3f522445dfbea63becc8129513b476c40c610aa56b659e4a28d7bd40"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "144ae236c82cd831df54d1c14839995b0b019d5c26140676f0167611bf41ea78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e738831f2697731f07d2696692c55b957f468ec0c3392f9260937cd17eb9fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83bd40bb6453ba0006d49943d4a992515462c04b3aadb1fd795dbe49aa3895b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb77dbcea450cc4070a6902c6034cd5e9abd7fa3088faacf1a3b5b6a0eeddaa"
    sha256 cellar: :any,                 x86_64_linux:  "16041177b906d467d6dc2ebec6ecbdecb3bb479bc987c729dd03243cbec99981"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
