class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "224742353727085ce04eebba768e6460018d46a9de47b3322cf44bcc0fdc98fb"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d89a85739ae7b00a59d4e110d79948e3d66f8427913aa7412e3aa489ceee0883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d89a85739ae7b00a59d4e110d79948e3d66f8427913aa7412e3aa489ceee0883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d89a85739ae7b00a59d4e110d79948e3d66f8427913aa7412e3aa489ceee0883"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b71bb9bd2c59a9a6a12fd57469a459d6baab4a3490193d5e00a8233dcaeda8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b71bb9bd2c59a9a6a12fd57469a459d6baab4a3490193d5e00a8233dcaeda8e"
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
