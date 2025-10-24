class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "9b0b455f747fabd1b8b8d90abaa438e9998ff4171e6e8b39d965ffef4a8d54f1"
  license "Apache-2.0"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

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
