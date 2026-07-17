class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.100.tar.gz"
  sha256 "a0de4e01956f8c965082f87dd7b2bbe283d2ab64d8f5117f00141ad078123466"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c7f8091b4e80afb9ad641af1cbf172be0893757ce8a1766903c22779ad2d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c7f8091b4e80afb9ad641af1cbf172be0893757ce8a1766903c22779ad2d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c7f8091b4e80afb9ad641af1cbf172be0893757ce8a1766903c22779ad2d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72979eb962a587a1d0c17d18399eb21536fdeab67eca400ba30268b9acc215a4"
    sha256 cellar: :any,                 x86_64_linux:  "dc4a48691b91b724a73b190a6f9d20b11b10eec6c61509dbeecea8d379702efb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
