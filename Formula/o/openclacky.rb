class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "20cef666b7e6c33abadafa0aea30707ee8a9f760c2904536e7eef88577028b19"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "047764381b0553bf79e1da3d8360e5b3f56f089bcd7ca5a57ab446b4f6fb59b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047764381b0553bf79e1da3d8360e5b3f56f089bcd7ca5a57ab446b4f6fb59b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "047764381b0553bf79e1da3d8360e5b3f56f089bcd7ca5a57ab446b4f6fb59b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e33eecc08048c7323658276b3333e9b2140d1010d3fa6f6f16409bf85a5e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e33eecc08048c7323658276b3333e9b2140d1010d3fa6f6f16409bf85a5e30"
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
