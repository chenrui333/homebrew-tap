class Lazynpm < Formula
  desc "TUI for npm"
  homepage "https://github.com/jesseduffield/lazynpm"
  url "https://github.com/jesseduffield/lazynpm/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "841583d686fa55872a4136627c0bed9d15edd6f87989a3a64ff7b28a0784254e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5cad900e82898feddd475d60b0e54653528b56a2fdea6ec9710e7c36187acea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c761c834974ca3b280a237a10dbe7d22ba8c54709dede46332e583f50e2df6dc"
    sha256 cellar: :any_skip_relocation, ventura:       "585173f0a0c6bffd15e945d2a420da87614edaf809b1b1c59d57624f995787c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c25badce8fad153f2cfccdd1380ea0e062f97df3b66ce637e6fd5d8aa5e00f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.buildSource=binaryRelease"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazynpm --version")
    assert_match "gui", shell_output("#{bin}/lazynpm --config")
  end
end
