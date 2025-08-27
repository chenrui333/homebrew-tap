class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "5c3fb3675615fe3abaad0565b018bb2a2645a60399fc9564267015ec397a5273"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9057d3064663688ce04f9afa90455a4fb28e0c7b00c31548b6f3e2364ea05250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebc4d39169d40fe285fc5f3f6aabdb06806dce2e661b6dbf0e12fd704da9c29c"
    sha256 cellar: :any_skip_relocation, ventura:       "9a4bec880ebc9741127067a181976d68273fbe45d9a3b6e0abef085ec24d5fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82148c09f395fd5de714f864aeb05fb7696551262daeb6447c0bff1477c4a466"
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
