# frozen_string_literal: true

# code based on:
#   https://github.com/stripe/homebrew-stripe-cli/blob/master/stripe.rb
# extended to support both macOS and Linux

class Stripe < Formula
  desc "Stripe CLI utility"
  homepage "https://stripe.com"
  version "1.7.6"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/stripe/stripe-cli/releases/download/v1.7.6/stripe_1.7.6_mac-os_x86_64.tar.gz"
      sha256 "ea478e7cf984c27567530772ae684fed07b17b7b629df0beeb9444fa7c8f66da"
    elsif Hardware::CPU.arm?
      url "https://github.com/stripe/stripe-cli/releases/download/v1.7.6/stripe_1.7.6_mac-os_arm64.tar.gz"
      sha256 "d3d3ae7d1dedb55a87fc0672be79f414c48a704ae2f95ed452057dbf397574b7"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stripe/stripe-cli/releases/download/v1.7.6/stripe_1.7.6_linux_x86_64.tar.gz"
    sha256 "4a82bd2d5c38260cefb0837d04016ba3c7f56949ff788d4090152616f4aa45b4"
  end

  def install
    bin.install "stripe"
    system bin/"stripe", "completion", "--shell", "bash"
    system bin/"stripe", "completion", "--shell", "zsh"
    bash_completion.install "stripe-completion.bash"
    zsh_completion.install "stripe-completion.zsh"
    (zsh_completion/"_stripe").write <<~EOS
      #compdef stripe
      _stripe () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/stripe-completion.zsh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      ❤ Thanks for installing the Stripe CLI! If this is your first time using the CLI, be sure to run `stripe login` first.
    EOS
  end

  test do
    system bin/"stripe", "--help"
  end
end
