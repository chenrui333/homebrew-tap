class Jules < Formula
  desc "Asynchronous coding agent from Google, in the terminal"
  homepage "https://jules.google/docs"
  url "https://registry.npmjs.org/@google/jules/-/jules-0.1.42.tgz"
  sha256 "84d85b13777236e4815b787910f4b74d1959cad3b3bf722f2b6306f3786a0f75"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "2453695685faeafc1b0d03b0df317704b8c7fb2d42fd15142ccebdf18179352b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"jules", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jules version")

    assert_match "Error: failed to list repos", shell_output("#{bin}/jules remote list --repo 2>&1")
  end
end
