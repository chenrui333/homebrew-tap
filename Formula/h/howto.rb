class Howto < Formula
  desc "Humble command-line assistant"
  homepage "https://github.com/nalgeon/howto"
  url "https://github.com/nalgeon/howto/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "336805619dd0cf5e59d10d376abfaf44d7c40f91dec6e982ea1db005784f5c78"
  license "MIT"
  head "https://github.com/nalgeon/howto.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc89c905937ea1c38457236b7757e00de07887a1924aa52891508f5ea36ef2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f03d6629b6b44b2913897f0371df075da0228c87d72e1f2c7b7563872696e7c"
    sha256 cellar: :any_skip_relocation, ventura:       "87b285f9134998f24430dfdaf584b50fde1f13ddc1fa055cfcf36b77f4df3a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e5e8c67011145741dae6a8a899bee7be77d61313f0b67ff7b8b4201837d317"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/howto --version")

    ENV["HOWTO_AI_TOKEN"] = "test"
    ENV["HOWTO_AI_MODEL"] = "gpt-4o"

    assert_match "401 Unauthorized", shell_output("#{bin}/howto curl example.org 2>&1", 1)
  end
end
