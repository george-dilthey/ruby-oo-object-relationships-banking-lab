require './lib/bank_account'

class Transfer

  attr_accessor :sender, :receiver, :amount, :status

  @@all = []

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = 'pending'
    @amount = amount
    @@all << self
  end

  def valid?
    sender.valid? && receiver.valid?
  end

  def execute_transaction
    if sender.balance - @amount > 0 && self.valid? && (@@all.select {|transfer| transfer.status == 'complete' && transfer == self}).length == 0
      sender.withdraw(@amount)
      receiver.deposit(@amount)
      @status = 'complete'
    else
      @status = 'rejected'
      "Transaction rejected. Please check your account balance."
    end
  end

  def reverse_transfer
    if self.status == 'complete'
      sender.deposit(@amount)
      receiver.withdraw(@amount)
      @status = 'reversed'
    end
  end
end
