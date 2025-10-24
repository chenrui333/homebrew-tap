class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9b0b455f747fabd1b8b8d90abaa438e9998ff4171e6e8b39d965ffef4a8d54f1"
  license "Apache-2.0"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6961ab43a3a2e44eb2f2013e7fbcf9b8159761f6b090b0829c2c19281985864f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6961ab43a3a2e44eb2f2013e7fbcf9b8159761f6b090b0829c2c19281985864f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6961ab43a3a2e44eb2f2013e7fbcf9b8159761f6b090b0829c2c19281985864f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d532c6ebb871c64a8a82c571244ef7c239d9c45469b60411e6d749c91a18d595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0edf7c2c6e2f8c137eda9b9b366104c234ee71826785574348280d91da23e85f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
