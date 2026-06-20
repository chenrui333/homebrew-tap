class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.79.1.tar.gz"
  sha256 "84988460d9f7acbe9e22341f34d272efbe07d05d4941f1e00c085270dca920fe"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a29451c7448773234a770ecdbcb74ed55734ef616c8f327f5ddee4f4df3e7bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64888fc055d308e9b587bcd881f6df7ce5e25251559f478294a39b3acb009b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96dd3b9fefb57e1e3c4145cd7547b0a7e50e21e8c004706856ad9227697d02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "748d004657be3704dfd032f30d34061b3588f95ee5aa0045b8f7d84a39cbcabe"
    sha256 cellar: :any,                 x86_64_linux:  "c010c7afc8ae9cbf967d61f430c89ba0ec2bf38d8426b1e2ed34064789d91fd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
