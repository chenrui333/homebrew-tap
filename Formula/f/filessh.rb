class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "44cb0b960cc3b65bf9db3934c66543f01e70bda142a34385eaa76b46628fcdf9"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29910995475859e52244fa10252549e0f9a8eb08f014b0fa8780a00be2bfadc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca3f9740c1da04805de65e1a2ffe76bf20d203d5658543fb0fab3e79cb6620f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d106dae3c1fb4b2c2a088ade8fb299f0d50d0c8e02f7d732d5be4b6e43d614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30778cef35a2ba0d376482915ccca1c3c7ed0f857a8fb215115b1563a96dd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb918a600209ae6db5771ab4da96e74cc5b16af75306e6b616bf5e92965e7f8f"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filessh --version")
    assert_match "You must provide a host", shell_output("#{bin}/filessh connect 2>&1", 1)
  end
end
