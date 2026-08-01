class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "96c2eba0225ab539391f037f03950dae3d9d960441797446b97b3198e7c1fe8b"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a97f3283dee54e183d060c15edc0e97050da405f93e1ba44f3d388845e5586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8a97f3283dee54e183d060c15edc0e97050da405f93e1ba44f3d388845e5586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a97f3283dee54e183d060c15edc0e97050da405f93e1ba44f3d388845e5586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6a719a6eb49a199fcfe541e4464739a2d74186fd0aa7d0ccf0a569b7b1f6e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a719a6eb49a199fcfe541e4464739a2d74186fd0aa7d0ccf0a569b7b1f6e2d"
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
