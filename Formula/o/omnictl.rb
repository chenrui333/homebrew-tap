class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "b15545f4e431a42b3b4b751d9d9b1aa87d0eb9f0fccc04c973e5cf3ed5bcca82"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59a1c2f48a33bfce6740b3cf64bef36ea7161675909c504cc219fc99ff525bb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a1c2f48a33bfce6740b3cf64bef36ea7161675909c504cc219fc99ff525bb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a1c2f48a33bfce6740b3cf64bef36ea7161675909c504cc219fc99ff525bb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83633125225fd3ede76f756264627959a81e2ca5fa18fd134d41022da3627499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5477eb87388fc1103dd9207410e27a2ababac97039b60af36be2ed3c781c4fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
