class MenderCli < Formula
  desc "General-purpose CLI for the Mender backend"
  homepage "https://github.com/mendersoftware/mender-cli"
  url "https://github.com/mendersoftware/mender-cli/archive/refs/tags/1.12.0.tar.gz"
  sha256 "7b68fdeef96a99ee4560cb9dccd673658b27e2f3a9be2e3451d204c50395caa0"
  license "Apache-2.0"
  head "https://github.com/mendersoftware/mender-cli.git", branch: "master"

  depends_on "go" => :build
  depends_on "xz" # required for lzma support

  def install
    ldflags = %W[
      -s -w
      -X github.com/mendersoftware/mender-cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mender-cli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mender-cli --version")

    output = shell_output("#{bin}/mender-cli devices list 2>&1", 1)
    assert_match "FAILURE: Please Login first", output
  end
end
