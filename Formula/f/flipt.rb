class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "a3a438127686cf1c93ad59f8804dd42f9419587af4c9096929b101326172297f"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef81f05c2ce9eb95ab8f901f0e0230ba84ba1c48fd7f19996e1427abdc87371b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adc8a34beab551c769ff33e35fd58ece9c681ab08a142a61e7196bd9f67741c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "932161fe380d7ad1cb12865a7ff63f19ef61ab12fa4ec6aa628d4b8fdfa20a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7386c26b4520ebf6d88ca16dd98de723c40da5efde4b6b2bee7b787445b05ae"
    sha256 cellar: :any,                 x86_64_linux:  "bb0ac229d621054baebfc6d4fd9790bc28e034311afbbb615213563a5f4f1f10"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "storage:\n  default:\n    backend:\n      type: memory", cfg.read
  end
end
