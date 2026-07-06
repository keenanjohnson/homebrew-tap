class Whatdidyoudo < Formula
  desc "Audit completed AI coding agent sessions: cross-check the agent's claims against what it actually did."
  homepage "https://github.com/keenanjohnson/whatdidyoudo"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/keenanjohnson/whatdidyoudo/releases/download/v0.1.0/whatdidyoudo-aarch64-apple-darwin.tar.xz"
      sha256 "5c509bcad0930d1b37f238ecf9a8af3e7d3977d15e54e3d8f1496583124227af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenanjohnson/whatdidyoudo/releases/download/v0.1.0/whatdidyoudo-x86_64-apple-darwin.tar.xz"
      sha256 "aa65970bc95cdb99ef843d730978f718846612dfd5e16548a76c28214f27c682"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/keenanjohnson/whatdidyoudo/releases/download/v0.1.0/whatdidyoudo-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee88d3a3fa9ec8fa3dc5f2ccdced1ebf91793c54c51c59b36eb1ed69ec558f69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/keenanjohnson/whatdidyoudo/releases/download/v0.1.0/whatdidyoudo-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f9936979aeac106aa18e8b4d2ad02d3ad05c8a2aac88c6d09d176f9eb73d836"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wdyd" if OS.mac? && Hardware::CPU.arm?
    bin.install "wdyd" if OS.mac? && Hardware::CPU.intel?
    bin.install "wdyd" if OS.linux? && Hardware::CPU.arm?
    bin.install "wdyd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
