class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "4913826b74f339e19a17c308558249926d64a9e12e982fdf5129e89ecebd06e2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c352b8a5eca2edc8afda38469e68962881b746e6c8c75d89f3509ef95f3e036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57b25bd194f8a9d7d7045c5ea106ddbb5a374ab168c968c03c35f41120fdd131"
    sha256 cellar: :any_skip_relocation, ventura:       "e668131dba047f53a832d7ed2994330aaa042415c1ce8ab170a285488f37837b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d487f7c14ae61a22b4387126e1fd4e10c9ce2ca901fed7d3539084fad8f48a5"
  end

  depends_on "go" => :build

  def install
    # Prevent init() from overwriting ldflags version
    inreplace "pkg/version/version.go",
              "if len(bi.Main.Version) > 0",
              "if len(bi.Main.Version) > 0 && Version == \"(dev)\""

    ldflags = "-s -w -X github.com/sjzar/chatlog/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chatlog version")
    assert_match "failed to get key", shell_output("#{bin}/chatlog key 2>&1")
  end
end
