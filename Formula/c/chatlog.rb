class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "3d89406c9b19e94fa3b0f7a8504d60233091eb1e86c95af69c8f24bf78e16755"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce3b1a6e9f0be16c048c1e52e3ae3cb77a969934c499609af04205eb95daf70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a1cad70f98b563d24901dfba2ca53d21ad31e772d179d063fd99d47ed2c75c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c303f2a82d4e407f49565770d4834515f4cc4e6dd17b2ef35bf8aff753afb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d67d491aba7baf5baaf951c36f1a5c9e7a51cd4a6dcaab265e2fea2ef2fde9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e70e12fc221e1f967c241a6e5e14d201e371de73dc7348953147518b69731d49"
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
