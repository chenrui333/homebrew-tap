class Howto < Formula
  desc "Humble command-line assistant"
  homepage "https://github.com/nalgeon/howto"
  url "https://github.com/nalgeon/howto/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "336805619dd0cf5e59d10d376abfaf44d7c40f91dec6e982ea1db005784f5c78"
  license "MIT"
  head "https://github.com/nalgeon/howto.git", branch: "main"

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
