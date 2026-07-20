class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "26e480f7253f55a1a70d9a9ab3e3194f1d4cca04ecb7a18072107f0e84517f1b"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54361ce501300dc57ab0d2b1fb3fe31a87d783ee1174be0d92f72e801ec09b71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54361ce501300dc57ab0d2b1fb3fe31a87d783ee1174be0d92f72e801ec09b71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54361ce501300dc57ab0d2b1fb3fe31a87d783ee1174be0d92f72e801ec09b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dc00da754a47074d10ec0b5a76960d3b4acf9c2c9d39b3a04db81c20667be1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dc00da754a47074d10ec0b5a76960d3b4acf9c2c9d39b3a04db81c20667be1d"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "git", "init"
    system "git", "add", "."
    system "gem", "build", "openclacky.gemspec"
    system "gem", "install", "--no-document", "openclacky-#{version}.gem"

    %w[clacky openclacky clarky].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin"/cmd, GEM_HOME: ENV["GEM_HOME"]
    end
  end

  test do
    assert_match "agent", shell_output("#{bin}/clacky help")
    assert_match "Commands", shell_output("#{bin}/openclacky help")
  end
end
