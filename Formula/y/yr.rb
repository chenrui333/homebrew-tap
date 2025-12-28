class Yr < Formula
  desc "Get the weather delivered to your command-line"
  homepage "https://git.sr.ht/~timharek/yr"
  url "https://git.sr.ht/~timharek/yr/archive/v1.0.0.tar.gz"
  sha256 "bc8980f06abc23b80fa2e8a8adcfbeeb3fa98b35d4ae883540c9e3c6cb627cba"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~timharek/yr", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb42f8077f2494424bc044bb6da060987b261328ea8d71b3b78c7f23c5bcd597"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb42f8077f2494424bc044bb6da060987b261328ea8d71b3b78c7f23c5bcd597"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb42f8077f2494424bc044bb6da060987b261328ea8d71b3b78c7f23c5bcd597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c64d0b86bbc121e2a7fb82f51fbe2189abd20d5dc9204534e3ce1216fe2db22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6caa51fb283113c5f6ca104ce87512b5699858bc9d384dacbac61d0f03c35fc6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/yr"

    generate_completions_from_executable(bin/"yr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yr --version")

    output = shell_output("#{bin}/yr now nyc")
    assert_match "City of New York", output
  end
end
