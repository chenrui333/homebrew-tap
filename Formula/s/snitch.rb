class Snitch < Formula
  desc "SNI-based host discovery tool for TLS layer reconnaissance"
  homepage "https://github.com/cirosec/SNItch"
  url "https://github.com/cirosec/SNItch/archive/refs/tags/v1.3-public.tar.gz"
  sha256 "16374f63e97bb9feb25026087a27f1b444aa254d406bb042f6d4ddd59c739036"
  license "AGPL-3.0-only"
  head "https://github.com/cirosec/SNItch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41ba04b902b607a3875ba0dc1b67071b33d5ed91c8ed9b9b73858d01ce963be4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ba04b902b607a3875ba0dc1b67071b33d5ed91c8ed9b9b73858d01ce963be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ba04b902b607a3875ba0dc1b67071b33d5ed91c8ed9b9b73858d01ce963be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0d1e9201130b7d7df2d3263a8d2699ff8b802e2b4bfe80ab74281520e7a29ab"
    sha256 cellar: :any,                 x86_64_linux:  "c056a4f2b31c907b14d9a4c17ad9fe38cb802cbd42b8e24333aa464d54f3903d"
  end

  depends_on "go" => :build

  def install
    ENV["GOTOOLCHAIN"] = "local"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}")
    generate_completions_from_executable(bin/"snitch", shell_parameter_format: :cobra)
  end

  test do
    assert_match "SNItch version #{version}", shell_output("#{bin}/snitch --version")

    output = shell_output(bin/"snitch")
    assert_match "No targets or hosts found.", output
    assert_match "Provide targets as positional argument", output
  end
end
